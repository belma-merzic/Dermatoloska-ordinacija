using AutoMapper;
using DermatoloskaOrdinacija.Model;
using DermatoloskaOrdinacija.Model.Requests;
using DermatoloskaOrdinacija.Model.SearchObjects;
using DermatoloskaOrdinacija.Services.Database;
using DermatoloskaOrdinacija.Services.ProizvodiStateMachine;
using Microsoft.EntityFrameworkCore.Metadata.Internal;
using Microsoft.ML.Data;
using Microsoft.ML.Trainers;
using Microsoft.ML;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;
using static Microsoft.EntityFrameworkCore.DbLoggerCategory;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.ML;
using Microsoft.ML.Data;
using Microsoft.ML.Trainers;
using Microsoft.EntityFrameworkCore;
using System.Data;
using System.Reflection;

namespace DermatoloskaOrdinacija.Services
{
    public class ProizvodiService : BaseCRUDService<Model.Proizvod, Database.Proizvod, ProizvodSearchObject, ProizvodInsertRequest, ProizvodUpdateRequest>, IProizvodiService
    {
        public BaseState _baseState { get; set; }
        public ProizvodiService(BaseState baseState, _200019Context context, IMapper mapper) : base(context, mapper)
        {
            _baseState = baseState;
        }

        public override IQueryable<Database.Proizvod> AddFilter(IQueryable<Database.Proizvod> query, ProizvodSearchObject? search = null)
        {
            var filteredQuery = base.AddFilter(query, search);

            if (!string.IsNullOrWhiteSpace(search?.FTS))
            {
                filteredQuery = filteredQuery.Where(x => x.Naziv.Contains(search.FTS) || x.Sifra.Contains(search.FTS));
            }

            if (!string.IsNullOrWhiteSpace(search?.Sifra))
            {
                filteredQuery = filteredQuery.Where(x => x.Sifra == search.Sifra);
            }

            return filteredQuery;
        }

        public override Task<Model.Proizvod> Insert(ProizvodInsertRequest insert)
        {
            var state = _baseState.CreateState("initial");

            return state.Insert(insert);
        }

        public override Task<Model.Proizvod> Delete(int id)
        {
            return base.Delete(id);
        }

        public override async Task<Model.Proizvod> Update(int id, ProizvodUpdateRequest update)
        {
            var entity = await _context.Proizvods.FindAsync(id);

            var state = _baseState.CreateState(entity.StateMachine);

            return await state.Update(id, update);
        }

        public async Task<Model.Proizvod> Activate(int id)
        {
            var entity = await _context.Proizvods.FindAsync(id);

            var state = _baseState.CreateState(entity.StateMachine);

            return await state.Activate(id);
        }

        public async Task<Model.Proizvod> Hide(int id)
        {
            var entity = await _context.Proizvods.FindAsync(id);

            var state = _baseState.CreateState(entity.StateMachine);

            return await state.Hide(id);
        }

        public async Task<List<string>> AllowedActions(int id)
        {
            var entity = await _context.Proizvods.FindAsync(id);
            var state = _baseState.CreateState(entity?.StateMachine ?? "initial");

            return await state.AllowedActions();
        }


        /*  static object isLocked = new object();
          static MLContext mlContext = null;
          static ITransformer modeltr = null;
          public List<Model.Proizvod> Recommend(int id)
          {

              mlContext = new MLContext();

              var tmpData = _context.Narudzbas.Include("StavkaNarudzbes").ToList();

              var data = new List<RatingEntry>();

              foreach (var x in tmpData)
              {
                  if (x.StavkaNarudzbes.Count > 1)
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
              };

              //////////////////////////////////////////////////////////////////////////////////////////
              DataTable dataTable = new DataTable(typeof(RatingEntry).Name);

              PropertyInfo[] Props = typeof(RatingEntry).GetProperties(BindingFlags.Public | BindingFlags.Instance);
              foreach (PropertyInfo prop in Props)
              {
                  dataTable.Columns.Add(prop.Name);
              }
              foreach (var item in data)
              {
                  var values = new object[Props.Length];
                  for (int i = 0; i < Props.Length; i++)
                  {
                      values[i] = Props[i].GetValue(item, null);
                  }
                  dataTable.Rows.Add(values);
              }

              if (dataTable.Rows.Count == 0)
                  return null;
              string myTableAsString =
              String.Join(Environment.NewLine, dataTable.Rows.Cast<DataRow>().
                  Select(r => r.ItemArray).ToArray().
                  Select(x => String.Join("\t", x.Cast<string>())));

              File.WriteAllTextAsync("img/WriteText.txt", myTableAsString);


              var putanja1 = System.Environment.CurrentDirectory + @"\img\" + "WriteText.txt";
              if (putanja1 == null)
                  throw new Exception("Nema putanje");
          //////////////////////////////////////////////////////////////////////////////////////////


                 var traindata = mlContext.Data.LoadFromEnumerable(data);
                 MatrixFactorizationTrainer.Options options = new MatrixFactorizationTrainer.Options();
                 options.MatrixColumnIndexColumnName = nameof(RatingEntry.RatingId);
                 options.MatrixRowIndexColumnName = nameof(RatingEntry.CoRatingId);
                 options.LabelColumnName = "Label";
                 options.LossFunction = MatrixFactorizationTrainer.LossFunctionType.SquareLossOneClass;
                 options.Alpha = 0.01;
                 options.Lambda = 0.025;
                 var est = mlContext.Recommendation().Trainers.MatrixFactorization(options);

                 modeltr = est.Fit(traindata);


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



         }
         public class CoRating_prediction
         {
             public float Score { get; set; }
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
         }*/
    }
}

