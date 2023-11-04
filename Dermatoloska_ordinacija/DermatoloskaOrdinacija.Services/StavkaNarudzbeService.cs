using AutoMapper;
using DermatoloskaOrdinacija.Model.Requests;
using DermatoloskaOrdinacija.Model.SearchObjects;
using DermatoloskaOrdinacija.Services.Database;
using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DermatoloskaOrdinacija.Services
{
    public class StavkaNarudzbeService : BaseCRUDService<Model.StavkaNarudzbe, Database.StavkaNarudzbe, StavkaNarudzbeSearchObject, StavkaNarudzbeInsertRequest, StavkaNarudzbeUpdateRequest>, IStavkaNarudzbeService
    {
        private readonly IHttpContextAccessor _httpContextAccessor;

        public StavkaNarudzbeService(_200019Context context, IMapper mapper, IHttpContextAccessor httpContextAccessor)
            : base(context, mapper)
        {
            _httpContextAccessor = httpContextAccessor;
        }

        public override IQueryable<StavkaNarudzbe> AddFilter(IQueryable<StavkaNarudzbe> query, StavkaNarudzbeSearchObject? search = null)
        {
            if (search?.NarudzbaId != 0)
            {
                query = query.Where(x => x.NarudzbaId == search.NarudzbaId);
            }

            return base.AddFilter(query, search);
        }

    }
}
