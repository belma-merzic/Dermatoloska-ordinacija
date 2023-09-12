using DermatoloskaOrdinacija.Model.Requests;
using DermatoloskaOrdinacija.Model;
using DermatoloskaOrdinacija.Services;
using Microsoft.AspNetCore.Mvc;

namespace DermatoloskaOrdinacija.Controllers
{
    [ApiController]
    public class DojamController : BaseCRUDController<Model.Dojam, Model.SearchObjects.DojamSearchObject, Model.Dojam, Model.Dojam>
    {
        public DojamController(ILogger<BaseController<Dojam, Model.SearchObjects.DojamSearchObject>> logger, IDojamService service)
            : base(logger, service)
        {
        }
    }
}
