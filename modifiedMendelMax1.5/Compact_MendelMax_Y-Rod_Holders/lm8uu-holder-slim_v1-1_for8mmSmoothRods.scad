// LM8UU holder slim v1.1
// *********************************************
// Jonas Kühling
// http://www.jonaskuehling.de
// http://www.thingiverse.com/jonaskuehling
// *********************************************
// derived from:
// http://www.thingiverse.com/thing:14942

// LM8UU/rod dimensions
LM8UU_dia = 8;
LM8UU_length = 12;
rod_dia = 2;

//screw/nut dimensions (M3) - hexagon socket head cap screw ISO 4762, hexagon nut ISO 4032
screw_thread_dia_iso = 3;
screw_head_dia_iso = 5.5;
nut_wrench_size_iso = 5.5;


// screw/nut dimensions for use (plus clearance for fitting purpose)
clearance_dia = 0.5;
screw_thread_dia = screw_thread_dia_iso + clearance_dia;
screw_head_dia = screw_head_dia_iso + clearance_dia;
nut_wrench_size = nut_wrench_size_iso + clearance_dia;
nut_dia_perimeter = (nut_wrench_size/cos(30));
nut_dia = nut_dia_perimeter;
nut_surround_thickness = 2;

// main body dimensions
body_wall_thickness = 4;
body_width = LM8UU_dia + (2*body_wall_thickness);
body_height = body_width;
body_length = LM8UU_length;
gap_width = rod_dia + 2;
screw_bushing_space = 1;
screw_elevation = LM8UU_dia + body_wall_thickness + (screw_thread_dia/2) +screw_bushing_space;

// TEST - uncomment to render in openscad:
// lm8uu_holder(1);		// WITH mountplate
 lm8uu_holder();		// WITHOUT mountplate


// nophead's polyhole module for better lm8uu-fit
module polyhole(d,h) {
    n = max(round(2 * d),3);
    rotate([0,0,180])
        cylinder(h = h, r = (d / 2) / cos (180 / n), $fn = n);
}


module mount_plate()
{
	difference()
	{
		translate([0,0,1.5])
		cube([body_width+2*screw_head_dia+4*nut_surround_thickness,screw_head_dia+2*nut_surround_thickness,3], center=true);

		for(i=[-1,1])
			translate([i*(body_width/2+nut_surround_thickness+screw_head_dia/2),0,-0.5])
				cylinder(r=screw_thread_dia/2, h=4, $fn=20);
	}
}

// main body
module lm8uu_holder(with_mountplate=false)
{
	difference()
	{
		union()
		{
			if (with_mountplate) 
			mount_plate();
	
			// body
			translate([0,0,body_height/4])
				cube([body_width,body_length,body_height/2], center=true);
			translate([0,0,(LM8UU_dia/2)+body_wall_thickness])		
				rotate([90,0,0])
					cylinder(r=(LM8UU_dia/2)+body_wall_thickness, h=LM8UU_length, center=true);
	
			// gap support
			translate([-(gap_width/2)-body_wall_thickness,-(body_length/2),body_height/2])
				cube([body_wall_thickness,LM8UU_length,(LM8UU_dia/2)+screw_bushing_space+(screw_thread_dia/2)]);
			translate([gap_width/2,-(body_length/2),body_height/2])
				cube([body_wall_thickness,LM8UU_length,(LM8UU_dia/2)+screw_bushing_space+(screw_thread_dia/2)]);
	
	
			// nut trap surround
			translate([gap_width/2,0,screw_elevation])
				rotate([0,90,0])
					cylinder(r=(((nut_wrench_size+nut_surround_thickness*2)/cos(30))/2), h=(body_width-gap_width)/2, $fn=6);
			translate([gap_width/2+(body_width-gap_width)/4,0,screw_elevation/2])
				cube([(body_width-gap_width)/2,nut_wrench_size+(nut_surround_thickness*2),screw_elevation],center=true);

			// Screw hole surround
			translate([-gap_width/2,0,screw_elevation])
				rotate([0,-90,0])
					cylinder(r=(screw_head_dia/2)+nut_surround_thickness, h=(body_width-gap_width)/2, $fn=20);
			translate([-(gap_width/2+(body_width-gap_width)/4),0,screw_elevation/2])
				cube([(body_width-gap_width)/2,screw_head_dia+(nut_surround_thickness*2),screw_elevation],center=true);
		}
	
		// bushing hole
		translate([0,0,LM8UU_dia/2+2])
			rotate([90,0,0])
//				cylinder(r=LM8UU_dia/2, h=LM8UU_length+1, center=true);
				translate([0,0,-(LM8UU_length+1)/2]) polyhole(LM8UU_dia,LM8UU_length+1);	// TESTING POLYHOLE MODULE FOR BETTER LM8UU FIT
	
		// top gap
		translate([-(gap_width/2),-(body_length/2)-1,body_height/2])
			cube([gap_width,LM8UU_length+2,(LM8UU_dia/2)+screw_bushing_space+(screw_thread_dia/2)+(nut_dia/2)+nut_surround_thickness+1]);
	
		// screw hole (one all the way through)
		translate([0,0,screw_elevation])
			rotate([0,90,0])
				cylinder(r=screw_thread_dia/2, h=body_width+3, center=true, $fn=20);
	
		// nut trap
		translate([gap_width/2+body_wall_thickness,0,screw_elevation])
			rotate([0,90,0])
				cylinder(r=nut_dia/2, h=body_width/2-gap_width/2-body_wall_thickness+1,$fn=6);
	
		// screw head hole
		translate([-(gap_width)/2-body_wall_thickness,0,screw_elevation])
			rotate([0,-90,0])
				cylinder(r=screw_head_dia/2, h=body_width/2-gap_width/2-body_wall_thickness+1,$fn=20);
	
	}
}