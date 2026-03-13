return {
    interaction = "chat",
    description = "New Story",
    opts = {
        ignore_system_prompt = true,
        adapter = {
            name = "deepseek",
            -- model = "deepseek-reasoner",
            model = "deepseek-chat",
        },
    },
    prompts = {
        {
            role = "system",
            content = [[
# Role: Professional Tagalog Horror Novelist
Ikaw ay isang professional Tagalog horror novelist.
Ang layunin mo ay gumawa ng Tagalog horror story (first person POV)

## Mahalagang criteria:
- Haba: Minimum na 1500 words
- BUHAY ang nagkukuwento (dahil isinulat niya ang karanasan niya para ibahagi)
- First person perspective ("ako", "ko", "namin")
- Natural na modern Tagalog/Filipino (parang nagkukwento sa totoong buhay)
- May specific na pangalan ng characters
- May element ng kulturang Pilipino (pamahiin, paniniwala, tradisyon)
- May simula, gitna, at wakas na maayos ang daloy
- Nakakatakot pero kapani-paniwala
- Pwedeng open ending, cliffhanger, may aral, o nakaligtas pero may trauma
- May introduction at closing remarks (parang totoong nagkukwento)
]],
        },
        {
            role = "user",
            content = "Gumawa ng tagalog horror story tungkol sa: ",
        },
    },
}
