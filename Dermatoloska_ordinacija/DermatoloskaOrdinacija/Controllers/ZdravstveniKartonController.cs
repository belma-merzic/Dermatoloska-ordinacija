using DermatoloskaOrdinacija.Model;
using DermatoloskaOrdinacija.Model.Requests;
using DermatoloskaOrdinacija.Model.SearchObjects;
using DermatoloskaOrdinacija.Services;

namespace DermatoloskaOrdinacija.Controllers
{
    public class ZdravstveniKartonController : BaseCRUDController<ZdravstveniKarton, ZdravstveniKartonSearchObject, ZdravstevniKartonInsertRequest, ZdravstevniKartonUpdateRequest>
    {
        public ZdravstveniKartonController(ILogger<BaseController<ZdravstveniKarton, ZdravstveniKartonSearchObject>> logger, IZdravstveniKartonService service) 
            : base(logger, service)
        {
        }
    }
}
