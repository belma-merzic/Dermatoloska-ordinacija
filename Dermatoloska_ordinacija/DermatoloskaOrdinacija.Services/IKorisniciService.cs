using DermatoloskaOrdinacija.Model;
using DermatoloskaOrdinacija.Model.Requests;
using DermatoloskaOrdinacija.Model.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DermatoloskaOrdinacija.Services
{
    public interface IKorisniciService : ICRUDService<Model.Korisnik, KorisnikSearchObject, KorisnikInsertRequest, KorisnikUpdateRequest>
    {
        Task<Model.Korisnik> Login(string username, string password);
    }
}
