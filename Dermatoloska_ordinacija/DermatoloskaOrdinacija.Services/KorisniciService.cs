using AutoMapper;
using Azure.Core;
using DermatoloskaOrdinacija.Model;
using DermatoloskaOrdinacija.Model.Requests;
using DermatoloskaOrdinacija.Model.SearchObjects;
using DermatoloskaOrdinacija.Services.Database;
using DermatoloskaOrdinacija.Services.ProizvodiStateMachine;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

namespace DermatoloskaOrdinacija.Services
{
    public class KorisniciService : BaseCRUDService<Model.Korisnik, Database.Korisnik, KorisnikSearchObject, KorisnikInsertRequest, KorisnikUpdateRequest>, IKorisniciService
    {
        public KorisniciService(_200019Context context, IMapper mapper) 
            :base(context, mapper) 
        {

        }

        public override Task<Model.Korisnik> Insert(KorisnikInsertRequest insert)
        {
            return base.Insert(insert);
        }

        public override Task<Model.Korisnik> Delete(int id)
        {
            return base.Delete(id);
        }

        public override async Task BeforeInsert(Database.Korisnik entity, KorisnikInsertRequest insert)
        {
            entity.LozinkaSalt = GenerateSalt();
            entity.LozinkaHash = GenerateHash(entity.LozinkaSalt, insert.Password);
        }

        public override IQueryable<Database.Korisnik> AddFilter(IQueryable<Database.Korisnik> query, KorisnikSearchObject? search = null)
        {
            if (!string.IsNullOrEmpty(search?.Ime)) 
            {
                query = query.Where(x => x.Ime.StartsWith(search.Ime));
            }

            if (!string.IsNullOrEmpty(search?.FTS))
            {
                query = query.Where(x => x.Ime.Contains(search.FTS));
            }

            if (!string.IsNullOrEmpty(search?.TipKorisnika))
            {
                query = query.Where(x => x.TipKorisnika.Tip.Contains(search.TipKorisnika));
            }

            if(search.KorisnikId != null)
            {
                query = query.Where(x => x.KorisnikId == search.KorisnikId);
            }

            return base.AddFilter(query, search);
        }

        public override IQueryable<Database.Korisnik> AddInclude(IQueryable<Database.Korisnik> query, KorisnikSearchObject? search = null)
        {
            if(search?.IsUlogeIncluded == true)
            {
                query = query.Include(x => x.TipKorisnika);
            }
            return base.AddInclude(query, search);
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
                throw new UserException("Invalid username or password.");

            var hash = GenerateHash(entity.LozinkaSalt, password);

            if (hash != entity.LozinkaHash)
                throw new UserException("Invalid username or password.");

            return _mapper.Map<Model.Korisnik>(entity);
        }

        public override async Task<Model.Korisnik> Update(int id, KorisnikUpdateRequest update)
        {
            var entity = await _context.Korisniks.FindAsync(id);
            return await base.Update(id, update);
        }
    }
}
