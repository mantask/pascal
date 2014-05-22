const cx =
      cy =
      cz =
{centro koordinates}

Procedure Pix3d( var outx, outy : integer; x, y, z : real);
  var a : integer;
begin
  a := round (z - cz);
  if a = 0 then a := 1;
  outx := round (256 * x / a) + cx;
  outy := round (256 * y / a) + cy;
end;

