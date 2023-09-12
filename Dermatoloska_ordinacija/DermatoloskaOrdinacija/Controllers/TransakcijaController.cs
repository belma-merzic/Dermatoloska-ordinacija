using DermatoloskaOrdinacija.Model.Requests;
using DermatoloskaOrdinacija.Model.SearchObjects;
using DermatoloskaOrdinacija.Services;
using Microsoft.AspNetCore.Mvc;

namespace DermatoloskaOrdinacija.Controllers
{
    [ApiController]
    public class TransakcijaController : BaseCRUDController<Model.Transakcija, BaseSearchObject, TransakcijaUpsertRequest, TransakcijaUpsertRequest>
    {
        public TransakcijaController(ILogger<BaseController<Model.Transakcija, BaseSearchObject>> logger, ITransakcijaService service)
            : base(logger, service)
        {
        }
    }
}
