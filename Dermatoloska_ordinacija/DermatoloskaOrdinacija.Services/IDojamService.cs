using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DermatoloskaOrdinacija.Services
{
    public interface IDojamService : ICRUDService<Model.Dojam, Model.SearchObjects.DojamSearchObject, Model.Dojam, Model.Dojam>
    {
    }
}
