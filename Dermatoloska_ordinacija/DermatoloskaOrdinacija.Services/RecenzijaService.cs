using AutoMapper;
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
    public class RecenzijaService : BaseCRUDService<Model.Recenzija, Database.Recenzija, RecenzijaSearchObject, RecenzijaInsertRequest, RecenzijaUpdateRequest>, IRecenzijaService
    {
        public RecenzijaService(_200019Context context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Recenzija> AddFilter(IQueryable<Recenzija> query, RecenzijaSearchObject? search = null)
        {
            var filteredQuery = base.AddFilter(query, search);

            if (search.ProizvodId != null && search.ProizvodId != 0)
            {
                filteredQuery = filteredQuery.Where(x => x.ProizvodId == search.ProizvodId);
            }

            return filteredQuery;
        }
    }
}