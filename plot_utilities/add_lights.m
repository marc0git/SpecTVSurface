
function ls = add_lights()
  % ADD_LIGHTS  Add 5 lights  based on the current camera
  %
  %ls = add_lights()
  %
  % Outputs:
  %   ls  #ls list of light handles
  %
  pink=[254 194 194]/255;
   teal = [144 216 196]/255;
lights = @() { ...
light('Color',1.0*[1 1 1],'Position',(campos-camtarget),'Style','local'), ...
light('Color',0.5*teal,'Position', (campos-camtarget)*axisangle2matrix([0 0 1],pi/2),'Style','local'), ...
light('Color',0.5*teal,'Position',-(campos-camtarget)*axisangle2matrix([0 0 1],pi/2),'Style','local'), ...
light('Color',0.5*pink,'Position', (campos-camtarget)*axisangle2matrix([1 0 0],pi*0.9),'Style','local'), ...
light('Color',0.5*pink,'Position', (campos-camtarget)*axisangle2matrix([1 0 0],-pi*0.9),'Style','local') ...
};
  ls = lights();
end