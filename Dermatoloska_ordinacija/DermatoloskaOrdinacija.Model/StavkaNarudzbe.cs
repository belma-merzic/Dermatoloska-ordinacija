using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DermatoloskaOrdinacija.Model
{
    public class StavkaNarudzbe
    {
        public int StavkaNarudzbeId { get; set; }

        public int? Kolicina { get; set; }

        public int? ProizvodId { get; set; }
        public int? NarudzbaId { get; set; }
    }
}
