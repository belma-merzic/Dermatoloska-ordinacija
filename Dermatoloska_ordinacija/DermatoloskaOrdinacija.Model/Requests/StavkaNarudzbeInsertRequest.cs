﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DermatoloskaOrdinacija.Model.Requests
{
    public class StavkaNarudzbeInsertRequest
    {
        public int? ProizvodID { get; set; }
        public int? Kolicina { get; set; }
    }
}
