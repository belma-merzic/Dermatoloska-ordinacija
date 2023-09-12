using DermatoloskaOrdinacija.Model;
using DermatoloskaOrdinacija.Model.Requests;
using DermatoloskaOrdinacija.Services;
using Microsoft.AspNetCore.Mvc;

namespace DermatoloskaOrdinacija.Controllers
{
    [ApiController]
    public class NovostiController : BaseCRUDController<Model.Novost, Model.SearchObjects.NovostSearchObject, NovostUpsertRequest, NovostUpsertRequest>
    {
        public NovostiController(ILogger<BaseController<Novost, Model.SearchObjects.NovostSearchObject>> logger, INovostiService service)
            : base(logger, service)
        {
        }
    }
}
