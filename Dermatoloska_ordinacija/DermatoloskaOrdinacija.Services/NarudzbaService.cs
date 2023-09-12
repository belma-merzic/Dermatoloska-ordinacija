﻿using AutoMapper;
using DermatoloskaOrdinacija.Model;
using DermatoloskaOrdinacija.Model.Requests;
using DermatoloskaOrdinacija.Model.SearchObjects;
using DermatoloskaOrdinacija.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DermatoloskaOrdinacija.Services
{
    public class NarudzbaService : BaseCRUDService<Model.Narudzba, Database.Narudzba, NarudzbaSearchObject, NarudzbaInsertRequest, NarudzbaUpdateRequest>, INarudzbaService
    {
        public NarudzbaService(_200019Context context, IMapper mapper) : base(context, mapper)
        {
        }

        public override async Task BeforeInsert(Database.Narudzba entity, NarudzbaInsertRequest insert)
        {
            double? _iznos = 0;
            foreach (var item in insert.Items)
            {
                var _artikal = _context.Proizvods.Where(x => x.ProizvodId == item.ProizvodId).FirstOrDefault();
                var x = _artikal.Cijena * item.Kolicina;
                double? y = (double?)x;
                _iznos += y;
            }
            entity.KorisnikId = insert.KorisnikID; 
            entity.Datum = DateTime.Now;
            entity.BrojNarudzbe = "#" + (_context.Narudzbas.Count() + 1).ToString();
            entity.Iznos = _iznos;
            entity.Status = "Pending";
            entity.StavkaNarudzbes = insert.Items.Select(item => new Database.StavkaNarudzbe
            {
                Kolicina = item.Kolicina,
                ProizvodId = item.ProizvodId,
            }).ToList();
        }

        public override IQueryable<Database.Narudzba> AddFilter(IQueryable<Database.Narudzba> query, NarudzbaSearchObject? search = null)
        {
            if (search?.KorisnikId != 0)
            {
                query = query.Where(x => x.KorisnikId == search.KorisnikId); 
            }

            return base.AddFilter(query, search);
        }
    }
}
