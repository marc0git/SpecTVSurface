function render_options(p)

shading interp;rotate(p,[0 1 0],20); rotate(p,[1 0 0],90);view([0 20 ]);
light('Position',[3 -7 8]);
%camlight
add_shadow;
lighting gouraud
p.SpecularExponent=300;p.SpecularStrength=0.8;
p.DiffuseStrength=0.8;p.AmbientStrength=0.2;p.SpecularColorReflectance=1;

end