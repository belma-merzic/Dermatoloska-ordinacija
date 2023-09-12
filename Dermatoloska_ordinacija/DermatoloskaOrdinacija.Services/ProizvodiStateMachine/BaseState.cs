using AutoMapper;
using DermatoloskaOrdinacija.Model;
using DermatoloskaOrdinacija.Model.Requests;
using DermatoloskaOrdinacija.Services.Database;
using Microsoft.Extensions.DependencyInjection;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DermatoloskaOrdinacija.Services.ProizvodiStateMachine
{
    public class BaseState
    {
        protected _200019Context _context; 
        protected IMapper _mapper { get; set; }
        public IServiceProvider _serviceProvider { get; set; }
        public BaseState(IServiceProvider serviceProvider, _200019Context context, IMapper mapper)
        {
            _context = context;
            _mapper = mapper;
            _serviceProvider = serviceProvider;
        }

        public virtual Task<Model.Proizvod> Insert(ProizvodInsertRequest request)
        {
            throw new UserException("Not allowed");
        }

        public virtual Task<Model.Proizvod> Update(int id, ProizvodUpdateRequest request)
        {
            throw new UserException("Not allowed");
        }

        public virtual Task<Model.Proizvod> Activate(int id)
        {
            throw new UserException("Not allowed");
        }

        public virtual Task<Model.Proizvod> Hide(int id)
        {
            throw new UserException("Not allowed");
        }

        public virtual Task<Model.Proizvod> Delete(int id)
        {
            throw new UserException("Not allowed");
        }

        public BaseState CreateState(string stateName) 
        {
            switch (stateName)
            {
                case "initial":
                case null:
                    return _serviceProvider.GetService<InitialProductState>();
                    break;
                case "draft":
                    return _serviceProvider.GetService<DraftProductState>();
                    break;
                case "active":
                    return _serviceProvider.GetService<ActiveProductState>();
                    break;

                default:
                    throw new UserException("Not allowed");
            }
        }

        public virtual async Task<List<string>> AllowedActions()
        {
            return new List<string>();
        }
    }
}
