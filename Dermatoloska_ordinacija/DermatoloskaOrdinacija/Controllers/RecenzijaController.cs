using DermatoloskaOrdinacija.Model.Requests;
using DermatoloskaOrdinacija.Services;
using Microsoft.AspNetCore.Mvc;

namespace DermatoloskaOrdinacija.Controllers
{
    [ApiController]
    public class RecenzijaController : BaseCRUDController<Model.Recenzija, Model.SearchObjects.RecenzijaSearchObject, RecenzijaInsertRequest, RecenzijaUpdateRequest>
    {
        public RecenzijaController(ILogger<BaseController<Model.Recenzija, Model.SearchObjects.RecenzijaSearchObject>> logger, IRecenzijaService service)
            : base(logger, service)
        {
        }
    }
}
