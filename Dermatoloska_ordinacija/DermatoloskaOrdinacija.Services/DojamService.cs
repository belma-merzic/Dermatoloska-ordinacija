using AutoMapper;
using DermatoloskaOrdinacija.Model.SearchObjects;
using DermatoloskaOrdinacija.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DermatoloskaOrdinacija.Services
{
    public class DojamService : BaseCRUDService<Model.Dojam, Database.Dojam, Model.SearchObjects.DojamSearchObject, Model.Dojam, Model.Dojam>, IDojamService
    {
        public DojamService(_200019Context context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Database.Dojam> AddFilter(IQueryable<Database.Dojam> query, DojamSearchObject search = null)
        {
            var filteredQuery = base.AddFilter(query, search);

            if (search.KorisnikId != null && search.KorisnikId != 0)
            {
                filteredQuery = filteredQuery.Where(x => x.KorisnikId == search.KorisnikId);
            }

            if (search.ProizvodId != null && search.ProizvodId != 0)
            {
                filteredQuery = filteredQuery.Where(x => x.ProizvodId == search.ProizvodId);
            }
            if (search.IsLiked != null && search.IsLiked != null)
            {
                filteredQuery = filteredQuery.Where(x => x.IsLiked == search.IsLiked);
            }


            return filteredQuery;
        }
    }
}
