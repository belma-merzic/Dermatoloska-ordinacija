using AutoMapper;
using DermatoloskaOrdinacija.Model;
using DermatoloskaOrdinacija.Model.Requests;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DermatoloskaOrdinacija.Services.ProizvodiStateMachine
{
    public class InitialProductState : BaseState
    {
        public InitialProductState(IServiceProvider serviceProvider, Database._200019Context context, IMapper mapper) 
            : base(serviceProvider, context, mapper)
        {
        }

        public override async Task<Proizvod> Insert(ProizvodInsertRequest request)
        {
            var set = _context.Set<Database.Proizvod>(); 
            var entity = _mapper.Map<Database.Proizvod>(request);

            entity.StateMachine = "draft";
            set.Add(entity);

            await _context.SaveChangesAsync();
            return _mapper.Map<Proizvod>(entity);
        }

        public override async Task<List<string>> AllowedActions()
        {
            var list = await base.AllowedActions();

            list.Add("Insert"); 

            return list;
        }
    }
}
