using DermatoloskaOrdinacija.Model;
using DermatoloskaOrdinacija.Model.Requests;
using DermatoloskaOrdinacija.Services;
using DermatoloskaOrdinacija.Services.Database;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore.Storage;
using System.Text;

namespace DermatoloskaOrdinacija.Controllers
{

    [ApiController]
    public class KorisniciController : BaseCRUDController<Model.Korisnik, Model.SearchObjects.KorisnikSearchObject, KorisnikInsertRequest, KorisnikUpdateRequest>
    {
        public KorisniciController(ILogger<BaseController<Model.Korisnik, Model.SearchObjects.KorisnikSearchObject>> logger, IKorisniciService service) 
            : base(logger, service)
        {
        }

        [AllowAnonymous]
        public override Task<Model.Korisnik> Insert([FromBody] KorisnikInsertRequest insert)
        {
            return base.Insert(insert);
        }
    }
}
