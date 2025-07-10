#!/bin/bash

# Define your HuggingFace API key
HUGGINGFACE_API_KEY="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"

# HuggingFace API endpoint
#API_ENDPOINT="https://api-inference.huggingface.co/models/gpt-3.5-turbo"
API_ENDPOINT="https://huggingface.co/TheBloke/WhiteRabbitNeo-13B-GGUF/blob/main/whiterabbitneo-13b.Q8_0.gguf
"

CHATGPT_CYAN_LABEL="\n\033[36mshellgpt \033[0m"

# ... Other constants and functions ...

# Request to HuggingFace API completions endpoint function
request_to_completions() {
    request_prompt="$1"
    response=$(curl -X POST "$API_ENDPOINT" \
        -H "Authorization: Bearer $HUGGINGFACE_API_KEY" \
        -H "Content-Type: application/json" \
        -d '{
            "inputs": "$request_prompt",
            "options": {
                "temperature": '$TEMPERATURE',
                "max_tokens": '$MAX_TOKENS'
            }
        }')
}

# ... Replace other OpenAI specific functions ...

# Parse command line arguments
# ... Same as before ...

# Loop for user interactions
while $running; do
    # ... Same as before ...

    if [[ "$prompt" =~ ^command: ]]; then
        # Escape quotation marks
        escaped_prompt=$(echo "$prompt" | sed 's/"/\\"/g')
        # Escape new lines
        request_prompt=$COMMAND_GENERATION_PROMPT${escaped_prompt//$'\n'/' '}
        build_user_chat_message "$chat_message" "$request_prompt"
        request_to_completions "$request_prompt"
        handle_error "$response"
        response_data=$(echo "$response" | jq -r '.choices[0].text')

        if [[ "$prompt" =~ ^command: ]]; then
            echo -e "${CHATGPT_CYAN_LABEL} ${response_data}\n"
         dangerous_commands=("rm" ">" "mv" "mkfs" ":(){:|:&};" "dd" "chmod" "wget" "curl")



            for dangerous_command in "${dangerous_commands[@]}"; do
                if [[ "$response_data" == *"$dangerous_command"* ]]; then
                    echo "Warning! This command can change your file system or download external scripts & data. Please do not execute code that you don't understand completely."
                fi
            done
            echo "Would you like to execute it? (Yes/No)"
            read run_answer
            if [ "$run_answer" == "Yes" ] || [ "$run_answer" == "yes" ] || [ "$run_answer" == "y" ] || [ "$run_answer" == "Y" ]; then
                echo -e "\nExecuting command: $response_data\n"
                eval $response_data
            fi
        fi
        response_data=$(echo "$response_data" | sed 's/"/\\"/g')
        add_assistant_response_to_chat_message "$chat_message" "$response_data"
        # ... Continue with the rest of the code ...

# ... Previous code ...

    elif [[ "$MODEL" =~ ^gpt- ]]; then
        # Escape quotation marks
        escaped_prompt=$(echo "$prompt" | sed 's/"/\\"/g')
        # Escape new lines
        request_prompt=${escaped_prompt//$'\n'/' '}

        build_user_chat_message "$chat_message" "$request_prompt"
        request_to_completions "$request_prompt"
        handle_error "$response"
        response_data=$(echo "$response" | jq -r '.choices[0].text')

        echo -e "${CHATGPT_CYAN_LABEL}${response_data}"

        response_data=$(echo "$response_data" | sed 's/"/\\"/g')
        add_assistant_response_to_chat_message "$chat_message" "$response_data"

        timestamp=$(date +"%d/%m/%Y %H:%M")
        echo -e "$timestamp $prompt \n$response_data \n" >> ~/shellgpt_scripting.sh

    else
        # Escape quotation marks
        escaped_prompt=$(echo "$prompt" | sed 's/"/\\"/g')
        # Escape new lines
        request_prompt=${escaped_prompt//$'\n'/' '}

        if [ "$CONTEXT" = true ]; then
            build_chat_context "$chat_context" "$escaped_prompt"
        fi

        request_to_completions "$request_prompt"
        handle_error "$response"
        response_data=$(echo "$response" | jq -r '.choices[0].text')

        echo -e "${CHATGPT_CYAN_LABEL}${response_data}"

        if [ "$CONTEXT" = true ]; then
            escaped_response_data=$(echo "$response_data" | sed 's/"/\\"/g')
            maintain_chat_context "$chat_context" "$escaped_response_data"
        fi

        timestamp=$(date +"%d/%m/%Y %H:%M")
        echo -e "$timestamp $prompt \n$escaped_response_data \n" | tee -a ~/shellgpt_scripting.sh
    fi

done

