using AutoMapper;
using DermatoloskaOrdinacija.Model.Requests;
using DermatoloskaOrdinacija.Model.SearchObjects;
using DermatoloskaOrdinacija.Services.Database;
using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using System.Security.Claims;



namespace DermatoloskaOrdinacija.Services
{
    public class NovostiService : BaseCRUDService<Model.Novost, Database.Novost, NovostSearchObject, NovostUpsertRequest, NovostUpsertRequest>, INovostiService
    {
        private readonly IHttpContextAccessor _httpContextAccessor;
        public NovostiService(_200019Context context, IMapper mapper, IHttpContextAccessor httpContextAccessor)
            : base(context, mapper) 
        {
            _httpContextAccessor = httpContextAccessor;
        }

        public override IQueryable<Database.Novost> AddFilter(IQueryable<Database.Novost> query, NovostSearchObject search = null)
        {
            var filteredQuery = base.AddFilter(query, search);

            if (!string.IsNullOrWhiteSpace(search?.Naslov))
            {
                filteredQuery = filteredQuery.Where(x => x.Naslov.StartsWith(search.Naslov));
            }
            return filteredQuery;
        }

        public override async Task BeforeInsert(Database.Novost entity, NovostUpsertRequest insert)
        {
            var loggedInUser = _httpContextAccessor.HttpContext.User;

            if (loggedInUser.Identity.IsAuthenticated)
            {
                string username = loggedInUser.Identity.Name;

                var user = await _context.Korisniks.FirstOrDefaultAsync(x => x.Username == username);

                if (user != null)
                {
                    entity.KorisnikId = user.KorisnikId;
                }
            }
        }

        public override async Task BeforeUpdate(Database.Novost entity, NovostUpsertRequest update)
        {
            var loggedInUser = _httpContextAccessor.HttpContext.User;

            if (loggedInUser.Identity.IsAuthenticated)
            {
                string username = loggedInUser.Identity.Name;

                var user = await _context.Korisniks.FirstOrDefaultAsync(x => x.Username == username);
                if (user != null)
                {
                    entity.KorisnikId = user.KorisnikId;
                }
            }
        }
    }
}
