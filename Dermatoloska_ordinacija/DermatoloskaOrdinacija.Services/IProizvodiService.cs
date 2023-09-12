using DermatoloskaOrdinacija.Model;
using DermatoloskaOrdinacija.Model.Requests;
using DermatoloskaOrdinacija.Model.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DermatoloskaOrdinacija.Services
{
    public interface IProizvodiService : ICRUDService<Proizvod, ProizvodSearchObject, ProizvodInsertRequest, ProizvodUpdateRequest>
    {
        Task<Proizvod> Activate(int id);
        Task<Proizvod> Hide(int id);
        Task<List<string>> AllowedActions(int id);
        List<Model.Proizvod> Recommend(int id);
    }
}
