using AutoMapper;
using DermatoloskaOrdinacija.Model;
using DermatoloskaOrdinacija.Model.Requests;
using DermatoloskaOrdinacija.Model.SearchObjects;
using DermatoloskaOrdinacija.Services.Database;
using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;
using Microsoft.ML;
using Microsoft.ML.Data;
using Microsoft.ML.Trainers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace DermatoloskaOrdinacija.Services
{
    public class RecommendResultService : BaseCRUDService<Model.RecommendResult, Database.RecommendResult, BaseSearchObject, RecommendResultUpsertRequest, RecommendResultUpsertRequest>, IRecommendResultService
    {
        public RecommendResultService(_200019Context context, IMapper mapper)
          : base(context, mapper)
        {
        }

        static MLContext mlContext = null;
        static object isLocked = new object();
        static ITransformer modeltr = null;



        public List<Model.Proizvod> Recommend(int? id)
        {
            lock (isLocked)// we lock it until it is finished
            {
                if (mlContext == null)
                {
                    mlContext = new MLContext();

                    var tmpData = _context.Narudzbas.Include("StavkaNarudzbes").ToList();

                    var data = new List<RatingEntry>();

                    foreach (var x in tmpData)
                    {
                        if ( x.StavkaNarudzbes.Count > 1)
                        {
                            var distinctItemId = x.StavkaNarudzbes.Select(y => y.ProizvodId).ToList();

                            distinctItemId.ForEach(y =>
                            {
                                var relatedItems = x.StavkaNarudzbes.Where(z => z.ProizvodId != y).ToList();

                                foreach (var z in relatedItems)
                                {
                                    data.Add(new RatingEntry()
                                    {
                                        RatingId = (uint)y,
                                        CoRatingId = (uint)z.ProizvodId,
                                    });
                                }
                            });
                        }
                    }
                    var traindata = mlContext.Data.LoadFromEnumerable(data);
                    MatrixFactorizationTrainer.Options options = new MatrixFactorizationTrainer.Options();
                    options.MatrixColumnIndexColumnName = nameof(RatingEntry.RatingId);
                    options.MatrixRowIndexColumnName = nameof(RatingEntry.CoRatingId);
                    options.LabelColumnName = "Label";
                    options.LossFunction = MatrixFactorizationTrainer.LossFunctionType.SquareLossOneClass;
                    options.Alpha = 0.01;
                    options.Lambda = 0.025;
                    options.NumberOfIterations = 100;
                    options.C = 0.00001;

                    var est = mlContext.Recommendation().Trainers.MatrixFactorization(options);

                    modeltr = est.Fit(traindata);
                }
            }

            var allItems = _context.Proizvods.Where(x => x.ProizvodId != id);
            var predictionResult = new List<Tuple<Database.Proizvod, float>>();

            foreach (var item in allItems)
            {
                var predictionEngine = mlContext.Model.CreatePredictionEngine<RatingEntry, Copurchase_prediction>(modeltr);
                var prediction = predictionEngine.Predict(new RatingEntry()
                {
                    RatingId = (uint)id,
                    CoRatingId = (uint)item.ProizvodId
                });

                predictionResult.Add(new Tuple<Database.Proizvod, float>(item, prediction.Score));
            }
            var finalResult = predictionResult.OrderByDescending(x => x.Item2).Select(x => x.Item1).Take(3).ToList();

            if (finalResult != null)
                return _mapper.Map<List<Model.Proizvod>>(finalResult);
            return null;
        }

        public class RatingEntry
        {
            [KeyType(count: 262111)]
            public uint RatingId { get; set; }
            [KeyType(count: 262111)]
            public uint CoRatingId { get; set; }
            public float Label { get; set; }

        }
        public class Copurchase_prediction
        {
            public float Score { get; set; }
        }

        public async Task<List<Model.RecommendResult>> TrainProductsModel()
        {
            var stavkeNarudzbe = _context.StavkaNarudzbes.ToList();
            var proizvodi = _context.Proizvods.ToList();

            if (proizvodi.Count > 4 && stavkeNarudzbe.Count() > 2)
            {
                List<Database.RecommendResult> recommendList = new List<Database.RecommendResult>();

                foreach (var proizvod in proizvodi)
                {
                    
                    var recommendedProducts = Recommend(proizvod.ProizvodId);

             
                    var resultRecommend = new Database.RecommendResult()
                    {
                        ProizvodId = proizvod.ProizvodId,
                        PrviProizvodId = recommendedProducts[0].ProizvodID,
                        DrugiProizvodId = recommendedProducts[1].ProizvodID,
                        TreciProizvodId = recommendedProducts[2].ProizvodID,
                    };
                    recommendList.Add(resultRecommend);
                }

                var list = _context.RecommendResults.ToList();
                var recordCount = list.Count(); 
                var proizvodiCount = _context.Proizvods.Count();
                if (recordCount != 0)
                {
                    if(recordCount > proizvodiCount) 
                    {
                        for (int i = 0; i < proizvodiCount; i++) 
                        {
                            list[i].ProizvodId = recommendList[i].ProizvodId;
                            list[i].PrviProizvodId = recommendList[i].PrviProizvodId;
                            list[i].DrugiProizvodId = recommendList[i].DrugiProizvodId;
                            list[i].TreciProizvodId = recommendList[i].TreciProizvodId;
                        }

                        for (int i = proizvodiCount; i < recordCount; i++) 
                        {
                            _context.RecommendResults.Remove(list[i]);
                        }
                    }
                    else 
                    {
                        for (int i = 0; i < recordCount; i++) 
                        {
                            list[i].ProizvodId = recommendList[i].ProizvodId;
                            list[i].PrviProizvodId = recommendList[i].PrviProizvodId;
                            list[i].DrugiProizvodId = recommendList[i].DrugiProizvodId;
                            list[i].TreciProizvodId = recommendList[i].TreciProizvodId;
                        }
                        var num = recommendList.Count() - recordCount;

                        if (num > 0) 
                        {
                            for (int i = recommendList.Count() - num; i < recommendList.Count(); i++)
                            {
                                _context.RecommendResults.Add(recommendList[i]);
                            }
                        }
                    }
                }
                else
                {
                    _context.RecommendResults.AddRange(recommendList); 
                }
                await _context.SaveChangesAsync();
                return _mapper.Map<List<Model.RecommendResult>>(recommendList);
            }
            else
            {
                throw new Exception("Not enough data to do recommmedation");
            }
        }

        public Task DeleteAllRecommendation()
        {
           return  _context.RecommendResults.ExecuteDeleteAsync();
        }

      
    }
}
