
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DermOrdDodatni.Services
{
    public interface IKorisniciService 
    {
        Task<Model.Korisnik> GetKorisnik(int  korisnikId);
        Task<Model.Korisnik> Login(string username, string password);
    }
}
