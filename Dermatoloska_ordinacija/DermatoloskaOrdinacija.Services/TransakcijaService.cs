using AutoMapper;
using DermatoloskaOrdinacija.Model.Requests;
using DermatoloskaOrdinacija.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DermatoloskaOrdinacija.Services
{
    public class TransakcijaService : BaseCRUDService<Model.Transakcija, Database.Transakcija, Model.SearchObjects.BaseSearchObject, TransakcijaUpsertRequest, TransakcijaUpsertRequest>, ITransakcijaService
    {
        public TransakcijaService(_200019Context context, IMapper mapper) : base(context, mapper)
        {
        }
    }
}