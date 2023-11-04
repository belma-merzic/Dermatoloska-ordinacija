using AutoMapper;
using Azure.Core;
using DermOrdDodatni.Database;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

namespace DermOrdDodatni.Services
{
    public class KorisniciService :IKorisniciService
    {

        protected _200019Context _context;
        protected IMapper _mapper { get; set; }

        public KorisniciService(_200019Context context, IMapper mapper) 
        {
            _context = context;
            _mapper = mapper;
        }

       

         public static string GenerateSalt()  
         {
             RNGCryptoServiceProvider provider = new RNGCryptoServiceProvider();
             var byteArray = new byte[16];
             provider.GetBytes(byteArray);


             return Convert.ToBase64String(byteArray);
         }
         public static string GenerateHash(string salt, string password) 
         {
             byte[] src = Convert.FromBase64String(salt);
             byte[] bytes = Encoding.Unicode.GetBytes(password);
             byte[] dst = new byte[src.Length + bytes.Length];

             System.Buffer.BlockCopy(src, 0, dst, 0, src.Length);
             System.Buffer.BlockCopy(bytes, 0, dst, src.Length, bytes.Length);

             HashAlgorithm algorithm = HashAlgorithm.Create("SHA1");
             byte[] inArray = algorithm.ComputeHash(dst);
             return Convert.ToBase64String(inArray);
         }

        public async Task<Model.Korisnik> Login(string username, string password)
        {
            var entity = await _context.Korisniks.Include(u => u.TipKorisnika).FirstOrDefaultAsync(x => x.Username == username);

            if (entity == null)
                throw new Exception("Invalid username or password.");

            var hash = GenerateHash(entity.LozinkaSalt, password);

            if (hash != entity.LozinkaHash)
                throw new Exception("Invalid username or password.");

            return _mapper.Map<Model.Korisnik>(entity);
        }

        public async Task<Model.Korisnik> GetKorisnik(int korisnikId)
        {
            var user = await _context.Korisniks.FindAsync(korisnikId);

            if (user == null) throw new Exception("No user");

            return _mapper.Map<Model.Korisnik>(user);
        }
    }
}
