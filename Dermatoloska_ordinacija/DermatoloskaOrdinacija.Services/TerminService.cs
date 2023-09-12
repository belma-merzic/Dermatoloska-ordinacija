using AutoMapper;
using DermatoloskaOrdinacija.Model.Requests;
using DermatoloskaOrdinacija.Model.SearchObjects;
using DermatoloskaOrdinacija.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;
using DermatoloskaOrdinacija.Model;
using DermatoloskaOrdinacija.Model.Requests;
using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Http;
using System.Security.Claims;
using Microsoft.AspNetCore.Http;



namespace DermatoloskaOrdinacija.Services
{
    public class TerminService : BaseCRUDService<Model.Termin, Database.Termin, TerminSearchObject, TerminInsertRequest, TerminUpdateRequest>, ITerminService
    {
        private readonly IHttpContextAccessor _httpContextAccessor;

        public TerminService(_200019Context context, IMapper mapper, IHttpContextAccessor httpContextAccessor)
            : base(context, mapper)
        {
            _httpContextAccessor = httpContextAccessor;
        }

        public override IQueryable<Database.Termin> AddFilter(IQueryable<Database.Termin> query, TerminSearchObject? search = null)
        {
            var filteredQuery = base.AddFilter(query, search);

            if (search.Doktor != null)
            {
                filteredQuery = filteredQuery.Where(x => x.KorisnikIdDoktorNavigation.Username.StartsWith(search.Doktor.ToString()));
            }
            if (search.Pacijent != null)
            {
                filteredQuery = filteredQuery.Where(x => x.KorisnikIdPacijentNavigation.Username.StartsWith(search.Pacijent.ToString()));
            }
            return filteredQuery;
        }
    }

}