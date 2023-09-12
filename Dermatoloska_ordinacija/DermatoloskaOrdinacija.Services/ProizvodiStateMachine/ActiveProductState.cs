using AutoMapper;
using DermatoloskaOrdinacija.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DermatoloskaOrdinacija.Services.ProizvodiStateMachine
{
    public class ActiveProductState : BaseState
    {
        public ActiveProductState(IServiceProvider serviceProvider, _200019Context context, IMapper mapper) 
            : base(serviceProvider, context, mapper)
        {
        }

        public override async Task<Model.Proizvod> Hide(int id)
        {
            var set = _context.Set<Database.Proizvod>();

            var entity = await set.FindAsync(id);

            entity.StateMachine = "draft";

            await _context.SaveChangesAsync();
            return _mapper.Map<Model.Proizvod>(entity);
        }

        public override async Task<List<string>> AllowedActions()
        {
            var list = await base.AllowedActions();

            list.Add("Hide"); 

            return list;
        }

    }
}
