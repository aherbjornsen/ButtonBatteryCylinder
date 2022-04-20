/*
    Parametric CRxxxx coin battery storage cylinder
    https://www.thingiverse.com/thing:xxxxxx
    
    remixed from design by Oliver Retzlaff @Oretz (https://www.thingiverse.com/thing:5193535)
    remixed from design by Marcin Laber @mlask (https://www.thingiverse.com/thing:5201315)
*/

use <text_on.scad>

model = 2032; // [1254: LR44, 927: CR927, 1025: CR1025, 1130: CR1130, 1216: CR1216, 1220: CR1220, 1225: CR1225, 1616: CR1616, 1620: CR1620, 1632: CR1632, 2012: CR2012, 2016: CR2016, 2020: CR2020, 2025: CR2025, 2032: CR2032, 2040: CR2040, 2320: CR2320, 2325: CR2325, 2330: CR2330, 2335: BR2335, 2354: CR2354, 2412: CR2412, 2430: CR2430, 2450: CR2450, 2477: CR2477, 3032: CR3032]

// default 20
Tray_items = 16;

Cover_font_size = 6;
Tray_font_size = 2;

Render_tray = true;
Render_cover = true;

/* [Additional configuration] */

// Tray/Cover wall width (a multiple of the nozzle size)
Wall_width = 1.2;

// battery spacer width
Spacer_width = 0.8;

// additional mm between Tray and Cover
Cover_tolerance = 0.2;

if (model == 1254) { container("LR44"); }
else if (model == 2335) { container("BR2335"); }
else { container(str("CR",model)); }

// Process
module container(model_str)
{
  Cover_text = model_str;
  Tray_text = model_str;
	
	Cell_diameter = round(model/100);
	Cell_width = (model % 100);

  H = Cell_width / 10; // in mm
	D = Cell_diameter + 0.8; // tolerance 0.8mm
  SW = Spacer_width > Wall_width ? Wall_width : Spacer_width; // spacer width cannot exceed wall width    
  CW = H + SW + 0.4; // cell compartment width;
   
  Tray_X = (Tray_items * CW) + (Wall_width * 2) - SW;
  Tray_D = D + (Wall_width * 2); // Tray diameter - cell diameter + two walls
  
  Cover_X = Tray_X + Wall_width;
  Cover_D = Tray_D + (Wall_width * 2) + (Cover_tolerance * 2); // Cover diameter
  
  Cover_Din = Tray_D + (Cover_tolerance * 2); // Inside diameter of cover
	
  e = 0.02;
	$fn = 100;
 
	if (Render_tray) {
		translate([0, -Cover_D - 2, 0]) rotate([0,90,0]) difference () {
			difference () {
				union() {
					difference () { // Create tray as hollow cylinder
						cylinder(h=Tray_X, d=Tray_D); 
						translate([0,0,Wall_width]) cylinder(h=Tray_X-Wall_width*2,d=Tray_D-Wall_width*2);
					}
					for (i = [0 : Tray_items]) {
						translate([0,0,(i*CW)+(Wall_width-SW)]){
							cylinder(h=SW,d=Tray_D);
						}
					}
				}
				translate([0, -Tray_D/2, -e])cube([Tray_D,Tray_D, Tray_X+2*e]); // Slice off half of cylinder
			}
			// translate first to place text correctly,the X adjustment is crude
			translate([-Wall_width*4-0.01*(Tray_font_size)*Cell_diameter,0,Tray_X]) text_on_cube(t=Tray_text, face="bottom",cube_size=Tray_X*2-0.4, size=Tray_font_size, extrusion_height=Wall_width/2, rotate=270); 
		}
		translate([-D/2+Wall_width, -D/4-Cover_D-2, 0]) cube([D/2,D/2,Wall_width*3]); // Add (crude) handle
	}
	    
	if (Render_cover) {
		difference () {
			difference () { // Move Cover to the side
				difference () {
					cylinder(h=Cover_X, d=Cover_D);
					translate([0,0,Wall_width]) cylinder(h=Cover_X, d=D+Cover_tolerance*2);
				}
				difference () {
					translate([0,0,Wall_width]) cylinder(h=Cover_X+Wall_width*2, d=Cover_Din);
					translate([Cover_tolerance*2, -Cover_D/2, 0]) cube([Cover_D,Cover_D, Cover_X+Wall_width*3+2*e]);
				}
			}
			text_on_cylinder(t=Cover_text,r=Cover_D/2-Wall_width/4,h=Cover_X, extrusion_height=Wall_width/2,size=Cover_font_size);
		}
	}
}