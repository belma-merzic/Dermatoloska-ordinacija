using DermatoloskaOrdinacija.Model.Requests;
using DermatoloskaOrdinacija.Model.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DermatoloskaOrdinacija.Services
{
    public interface INovostiService : ICRUDService<Model.Novost, NovostSearchObject, NovostUpsertRequest, NovostUpsertRequest>
    {
    }
}
