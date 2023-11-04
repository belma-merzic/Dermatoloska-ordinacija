using DermatoloskaOrdinacija.Model.Requests;
using DermatoloskaOrdinacija.Services;

namespace DermatoloskaOrdinacija.Controllers
{
    public class StavkaNarudzbeController : BaseCRUDController<Model.StavkaNarudzbe, Model.SearchObjects.StavkaNarudzbeSearchObject, StavkaNarudzbeInsertRequest, StavkaNarudzbeUpdateRequest>
    {
        public StavkaNarudzbeController(ILogger<BaseController<Model.StavkaNarudzbe, Model.SearchObjects.StavkaNarudzbeSearchObject>> logger, IStavkaNarudzbeService service)
            : base(logger, service)
        {
        }

    }
}
