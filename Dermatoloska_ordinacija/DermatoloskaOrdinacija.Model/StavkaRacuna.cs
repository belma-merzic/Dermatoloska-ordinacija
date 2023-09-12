using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DermatoloskaOrdinacija.Model
{
    public class StavkaRacuna
    {
        public int StavkaRacunaId { get; set; }

        public int? Kolicina { get; set; }

        public int? RacunId { get; set; }

        public int? ProizvodId { get; set; }

        public virtual Proizvod? Proizvod { get; set; }

        public virtual Racun? Racun { get; set; }
    }
}
