using DermatoloskaOrdinacija.Model;
using DermatoloskaOrdinacija.Model.SearchObjects;
using DermatoloskaOrdinacija.Services;
using Microsoft.AspNetCore.Mvc;

namespace DermatoloskaOrdinacija.Controllers
{
    [ApiController]
    public class VrsteProizvodumController : BaseController<Model.VrstaProizvodum, BaseSearchObject> //posto ne zelimo nijedan dodatan filter za Vrste Proizvoda proslijedimo mu samo object
    {
        public VrsteProizvodumController(ILogger<BaseController<Model.VrstaProizvodum, BaseSearchObject>> logger, 
            IService<Model.VrstaProizvodum, BaseSearchObject> service) : base(logger, service)
        {
        }
    }
}
