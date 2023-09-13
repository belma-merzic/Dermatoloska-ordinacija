using DermatoloskaOrdinacija.Model.Requests;
using DermatoloskaOrdinacija.Model.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DermatoloskaOrdinacija.Services
{
    public interface IRecommendResultService : ICRUDService<Model.RecommendResult, BaseSearchObject, RecommendResultUpsertRequest, RecommendResultUpsertRequest>
    {
        Task<List<Model.RecommendResult>> TrainProductsModel();
        Task DeleteAllRecommendation();
    }
}
