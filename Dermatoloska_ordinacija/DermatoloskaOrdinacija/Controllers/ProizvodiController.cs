using DermatoloskaOrdinacija.Model;
using DermatoloskaOrdinacija.Model.Requests;
using DermatoloskaOrdinacija.Services;
using DermatoloskaOrdinacija.Services.Database;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace DermatoloskaOrdinacija.Controllers
{

    [ApiController]
    public class ProizvodiController : BaseCRUDController<Model.Proizvod, Model.SearchObjects.ProizvodSearchObject, ProizvodInsertRequest, ProizvodUpdateRequest>
    {
        public ProizvodiController(ILogger<BaseController<Model.Proizvod, Model.SearchObjects.ProizvodSearchObject>> logger, IProizvodiService service) 
            : base(logger, service)
        {
        }

        [HttpPut("{id}/activate")]
        public virtual async Task<Model.Proizvod> Activate(int id)
        {
            return await (_service as IProizvodiService).Activate(id); 
        }

        [HttpPut("{id}/hide")]
        public virtual async Task<Model.Proizvod> Hide(int id)
        {
            return await (_service as IProizvodiService).Hide(id);
        }

        [HttpGet("{id}/allowedActions")]
        public virtual async Task<List<string>> AllowedActions(int id)
        {
            return await (_service as IProizvodiService).AllowedActions(id);
        }

       /* [HttpGet("{id}/Recommend")]

        public List<Model.Proizvod> Recommend(int id)
        {
            var result = (_service as IProizvodiService).Recommend(id);

            return result;
        }*/
    }
}
