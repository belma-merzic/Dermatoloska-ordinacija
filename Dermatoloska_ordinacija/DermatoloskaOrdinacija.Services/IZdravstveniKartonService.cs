using DermatoloskaOrdinacija.Model;
using DermatoloskaOrdinacija.Model.Requests;
using DermatoloskaOrdinacija.Model.SearchObjects;
using DermatoloskaOrdinacija.Services.Database;

namespace DermatoloskaOrdinacija.Services
{
    public interface IZdravstveniKartonService : ICRUDService<Model.ZdravstveniKarton, ZdravstveniKartonSearchObject, ZdravstevniKartonInsertRequest, ZdravstevniKartonUpdateRequest>
    {
    }
}
