using DermatoloskaOrdinacija.Model.Requests;
using DermatoloskaOrdinacija.Model.SearchObjects;
using DermatoloskaOrdinacija.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DermatoloskaOrdinacija.Services
{
    public interface ITransakcijaService : ICRUDService<Model.Transakcija, BaseSearchObject, TransakcijaUpsertRequest, TransakcijaUpsertRequest>
    {

    }
}
