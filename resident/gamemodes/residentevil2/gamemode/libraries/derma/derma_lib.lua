
function re2_create_UI_Object(parent, posX, posY, width, height, color, font, text, option)
  local pnt = parent or false
  local tfont = font or "default"
  local opt = option or 0
  local obj = ""
  local tcolor = color or Color(0,0,0)
        if opt == 0 then
          obj = vgui.Create("DButton",pnt)
        end
        if opt == 1 then
          obj = vgui.Create("DLabel",pnt)
        end
        if opt == 2 then
          obj = vgui.Create("DTextEntry",pnt)
        end
        if opt == 3 then
          obj = vgui.Create("DPanel",pnt)
          obj:SetPos(pnt:GetWide()*posX,pnt:GetTall()*posY)
          obj:SetSize(pnt:GetWide()*width,pnt:GetTall()*height)
        end
        if opt == 4 then
          if pnt == false then
            obj = vgui.Create("DFrame")
          else
            obj = vgui.Create("DFrame",pnt)
            obj:SetPos(pnt:GetWide()*posX,pnt:GetTall()*posY)
            obj:SetSize(pnt:GetWide()*width,pnt:GetTall()*height)
          end
          obj:SetDraggable(false)
          obj:ShowCloseButton(false)
          obj:SetTitle("")

        end

        if opt != 4 and opt != 3 then
          obj:SetPos(pnt:GetWide()*posX,pnt:GetTall()*posY)
          obj:SetSize(pnt:GetWide()*width,pnt:GetTall()*height)
          obj:SetFont(tfont)
          obj:SetText(text)
          obj:SetTextColor(tcolor)
      end
        return obj
end

function re2_create_Button(parent, posX, posY, width, height,tcolor, font, text)
  return re2_create_UI_Object(parent, posX, posY, width, height,tcolor, font, text, 0)
end


function re2_create_Label(parent, posX, posY, width, height,tcolor, font, text)
  return re2_create_UI_Object(parent, posX, posY, width, height,tcolor, font, text, 1)
end

function re2_create_TextEntry(parent, posX, posY, width, height,tcolor, font, text)
  return re2_create_UI_Object(parent, posX, posY, width, height,tcolor, font, text, 2)
end

function re2_create_Panel(parent, posX, posY, width, height,tcolor, font, text)
  return re2_create_UI_Object(parent, posX, posY, width, height,tcolor, font, text, 3)
end

function re2_create_Frame(parent, posX, posY, width, height,tcolor, font, text)
  return re2_create_UI_Object(parent, posX, posY, width, height,tcolor, font, text, 4)

end
