if not rowaasr13 then rowaasr13 = {} end

include("rowaasr13\!All.lua")

function rowaasr13.GetUnitPromotionsHelpText(unit)
   if unit:IsTrade() then return '' end
   if unit:GetBaseCombatStrength() <= 0 then return '' end

   local strPromotions = rowaasr13.UnitPromotionsHelpTextConcise(unit)
   if strPromotions then
      return '[NEWLINE]' .. strPromotions .. '[NEWLINE]'
   end

   return ''
end

function rowaasr13.UnitPromotionsHelpTextPlain(unit)
   local lines = {}
   for unitPromotion in GameInfo.UnitPromotions() do
      if unit:IsHasPromotion(unitPromotion.ID) then
         local help = Locale.ConvertTextKey(unitPromotion.Help)
         local desc = Locale.ConvertTextKey(unitPromotion.Description)
         if help == desc then desc = '*' end
         local line = help .. ' (' .. desc .. ')'
         lines[#lines + 1] = line
      end
   end
   if #lines > 0 then
      return table.concat(lines, '[NEWLINE]')
   end
end

function rowaasr13.UnitPromotionsHelpTextConcise(unit)
   local lines = {}
   local uniq_help = {}
   for unitPromotion in GameInfo.UnitPromotions() do
      if unit:IsHasPromotion(unitPromotion.ID) then
         local desc = Locale.ConvertTextKey(unitPromotion.Description)
         local help = Locale.ConvertTextKey(unitPromotion.Help)

         if help == desc then
            lines[#lines + 1] = help .. ' (*)'
         else
            local uniq_help_exists = uniq_help[help]
            if uniq_help_exists then
               uniq_help_exists[#uniq_help_exists + 1] = desc
            else
               lines[#lines + 1] = help
               uniq_help[help] = { desc }
            end
         end
      end
   end

   if #lines == 0 then return end

   for idx = 1, #lines do
      local line = lines[idx]
      local descs = uniq_help[line]
      if descs then
         lines[idx] = line .. ' (' .. table.concat(descs, ', ') .. ')'
      end
   end

   return table.concat(lines, '[NEWLINE]')
end