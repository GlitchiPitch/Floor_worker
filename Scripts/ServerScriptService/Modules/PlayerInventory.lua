local box: {
    billboard: BillboardGui,
    clickBillboard: BillboardGui,
    clickDetector: ClickDetector,
}

function openBox()
    box.clickBillboard.Enabled = not box.clickBillboard.Enabled
    box.billboard.Enabled = not box.billboard.Enabled
end

function init()
    box.clickBillboard.Enabled = true
    box.billboard.Enabled = false
    box.clickDetector.MouseClick:Connect(openBox)
end