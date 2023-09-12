using DermatoloskaOrdinacija.Model.Requests;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DermatoloskaOrdinacija.Services
{
    public interface IRecenzijaService : ICRUDService<Model.Recenzija, Model.SearchObjects.RecenzijaSearchObject, RecenzijaInsertRequest, RecenzijaUpdateRequest>
    { 
    }
}
