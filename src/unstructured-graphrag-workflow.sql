/**
    Tokenflow run : end-to-end workflow for the RAI GRS Snowflake app.
*/
SET project_id = 'tokenflow';

-- OpenAI models.
--SET llm_family = 'openai';
--SET completion_model = 'gpt-4o';
--SET embeddings_model = 'text-embedding-3-large';

-- Snowflake models.
SET llm_family = 'snowflake';
SET completion_model = 'claude-3-5-sonnet';
SET embeddings_model = 'snowflake-arctic-embed-m';

SET is_fine_tuned_completion_model = FALSE;
--SET openai_api_key = 'sk-proj-...';
SET openai_api_key = null; -- If we use Snowflake models we do not need OpenAI API key.
SET similarity_top_k = 10;
SET similarity_threshold = 0.01;

-- Corpus conversion: not needed as we upload CSV from notebook.
-- LIST @rai_grs_ilias.data.files;
-- CALL rai_grs_ilias.app.execute_convert_corpus(
--     $project_id
--     , 'markdown'
--     , True
-- );

-- (Optional) Retrieve estimation for the warehouse and compute resources required to run the project.
-- CALL rai_grs_ilias.app.get_sizing_advice($project_id, $llm_family);
-- Apply the estimation automatically.
-- -- CALL rai_grs_ilias.app.apply_auto_sizing($project_id, $llm_family);

-- Entities / relations extraction.
CALL rai_grs_ilias.app.execute_get_entities_relations(
    $project_id
    , $llm_family
    , $completion_model
    , $is_fine_tuned_completion_model
    , $openai_api_key
);

-- Community detection.
CALL rai_grs_ilias.app.execute_get_communities($project_id);

-- Graph indexing, summarization and embeddings.
CALL rai_grs_ilias.app.execute_get_embeddings(
    $project_id
    , $llm_family
    , $completion_model
    , $embeddings_model
    , 'CHUNK'
    , $is_fine_tuned_completion_model
    , $openai_api_key
);


-- Question answering.
WITH questions AS (
    SELECT 'Describe an agent from the medicine field.' AS question
    -- SELECT
    --     prompt AS question
    -- FROM
    --     rai_grs_ilias.data.extracted_qa AS eqa
    -- SAMPLE
    --     (1 ROWS)
    -- WHERE
    --     eqa.project_id = $project_id
)
, answer_context AS (
    SELECT
        q.question AS question
        , rai_grs_ilias.app.get_answer(
            $project_id
            , $llm_family
            , $completion_model
            , $embeddings_model
            , q.question
            , $is_fine_tuned_completion_model
            , $similarity_top_k
            , $similarity_threshold
            , $openai_api_key
        ) AS content
    FROM questions AS q
), first_flatten AS (
    SELECT
        ac.question AS question
        , value:answer::VARCHAR AS answer
        , value:context::ARRAY AS context
    FROM
        answer_context AS ac
        , LATERAL FLATTEN(ac.content)
)
SELECT
    ff.question AS question
    , ff.answer AS answer
    , ff.context AS context
FROM
    first_flatten AS ff;
