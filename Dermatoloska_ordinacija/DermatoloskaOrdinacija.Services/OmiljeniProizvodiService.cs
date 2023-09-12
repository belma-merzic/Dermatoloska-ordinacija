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
    public class OmiljeniProizvodiService : BaseCRUDService<Model.OmiljeniProizvodi, Database.OmiljeniProizvodi, Model.SearchObjects.OmiljeniProizvodiSearchObject, OmiljeniProizvodiUpsertRequest, OmiljeniProizvodiUpsertRequest>, IOmiljeniProizvodiService
    {
        public OmiljeniProizvodiService(_200019Context context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<OmiljeniProizvodi> AddFilter(IQueryable<OmiljeniProizvodi> query, OmiljeniProizvodiSearchObject? search = null)
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

            return filteredQuery;
        }
    }
}
