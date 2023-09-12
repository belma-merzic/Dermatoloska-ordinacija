using AutoMapper;
using DermatoloskaOrdinacija.Model.SearchObjects;
using DermatoloskaOrdinacija.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DermatoloskaOrdinacija.Services
{
    public class BaseCRUDService<T, TDb, TSearch, TInsert, TUpdate> : BaseService<T, TDb, TSearch> where T : class where TDb : class where TSearch : BaseSearchObject
    {
        public BaseCRUDService(_200019Context context, IMapper mapper) 
            : base(context, mapper)
        {
        }

        public virtual async Task BeforeInsert(TDb db, TInsert insert)
        {

        }

        public virtual async Task BeforeUpdate(TDb db, TUpdate update)
        {
            
        }

        public virtual async Task<T> Insert(TInsert insert)
        {
            var set = _context.Set<TDb>(); 
            TDb entity = _mapper.Map<TDb>(insert);
           
            set.Add(entity);
            await BeforeInsert(entity, insert);

            await _context.SaveChangesAsync();
            return _mapper.Map<T>(entity);
        }

        public virtual async Task<T> Update(int id, TUpdate update)
        {
            var set = _context.Set<TDb>();

             var entity = await set.FindAsync(id);

            
            _mapper.Map(update, entity);
            await BeforeUpdate(entity, update);

            await _context.SaveChangesAsync();
            return _mapper.Map<T>(entity);
        }

        public virtual async Task<T> Delete(int id)
        {
            var set = _context.Set<TDb>();

            foreach (var item in _context.OmiljeniProizvodis)
            {
                if (id == item.ProizvodId)
                {
                    _context.OmiljeniProizvodis.Remove(item);
                }
            }

            foreach (var item in _context.StavkaNarudzbes)
            {
                if (id == item.ProizvodId)
                {
                    _context.StavkaNarudzbes.Remove(item);
                }
            }

            var entity = await set.FindAsync(id);
            
            set.Remove(entity);
            await _context.SaveChangesAsync();
            return _mapper.Map<T>(entity);
        }

    }
}
