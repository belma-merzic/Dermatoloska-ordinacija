using DermatoloskaOrdinacija.Model.Requests;
using DermatoloskaOrdinacija.Services;
using Microsoft.AspNetCore.Mvc;
using DermatoloskaOrdinacija.Model;


namespace DermatoloskaOrdinacija.Controllers
{
    [ApiController]
    public class TerminController : BaseCRUDController<Model.Termin, Model.SearchObjects.TerminSearchObject, TerminInsertRequest, TerminUpdateRequest>
    {
        public TerminController(ILogger<BaseController<Termin, Model.SearchObjects.TerminSearchObject>> logger, ITerminService service)
            : base(logger, service)
        {
        }
    }
}
