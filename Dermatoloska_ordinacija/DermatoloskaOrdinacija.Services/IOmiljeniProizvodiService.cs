using DermatoloskaOrdinacija.Model.Requests;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DermatoloskaOrdinacija.Services
{
    public interface IOmiljeniProizvodiService : ICRUDService<Model.OmiljeniProizvodi, Model.SearchObjects.OmiljeniProizvodiSearchObject, OmiljeniProizvodiUpsertRequest, OmiljeniProizvodiUpsertRequest>
    {

    }
}
