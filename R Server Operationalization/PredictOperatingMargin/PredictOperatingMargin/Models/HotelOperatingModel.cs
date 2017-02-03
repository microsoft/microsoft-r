using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace PredictOperatingMargin.Models
{
    public class HotelOperatingModel
    {
        [Required(ErrorMessage = "Required")]
        public int numberOfRooms { get; set; }

        [Required(ErrorMessage = "Required.")]
        public double? nearestCompetition { get; set; }

        [Required(ErrorMessage = "Required.")]
        public double? cityAnnualVisitor { get; set; }

        [Required(ErrorMessage = "Required")]
        public double? cityMedianIncome { get; set; }
        
    }
}
