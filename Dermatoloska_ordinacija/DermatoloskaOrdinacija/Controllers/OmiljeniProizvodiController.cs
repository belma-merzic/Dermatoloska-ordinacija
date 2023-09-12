using DermatoloskaOrdinacija.Model.Requests;
using DermatoloskaOrdinacija.Services;
using Microsoft.AspNetCore.Mvc;

namespace DermatoloskaOrdinacija.Controllers
{
    [ApiController]
    public class OmiljeniProizvodiController : BaseCRUDController<Model.OmiljeniProizvodi, Model.SearchObjects.OmiljeniProizvodiSearchObject, OmiljeniProizvodiUpsertRequest, OmiljeniProizvodiUpsertRequest>
    {
        public OmiljeniProizvodiController(ILogger<BaseController<Model.OmiljeniProizvodi, Model.SearchObjects.OmiljeniProizvodiSearchObject>> logger, IOmiljeniProizvodiService service)
            : base(logger, service)
        {
        }
    }
}
