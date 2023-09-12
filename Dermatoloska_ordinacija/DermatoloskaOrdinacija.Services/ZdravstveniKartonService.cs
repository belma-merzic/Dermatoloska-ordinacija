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
    public class ZdravstveniKartonService : BaseCRUDService<Model.ZdravstveniKarton, Database.ZdravstveniKarton, ZdravstveniKartonSearchObject, ZdravstevniKartonInsertRequest, ZdravstevniKartonUpdateRequest>, IZdravstveniKartonService
    {
        public ZdravstveniKartonService(_200019Context context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<ZdravstveniKarton> AddFilter(IQueryable<ZdravstveniKarton> query, ZdravstveniKartonSearchObject? search = null)
        {
            if (search?.KorisnikId != 0)
            {
                query = query.Where(x => x.KorisnikId == search.KorisnikId);  
            }

            return base.AddFilter(query, search);
        }
    }
}
