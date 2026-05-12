INSERT INTO tbl_tags (
  id,
  name,
  color,
  created_at,
  updated_at
)
VALUES (
  '2d055627-4f42-4323-b0d0-cf5063ba04f7',
  'Student',
  '#60A5FA',
  now(),
  now()
)
ON CONFLICT (name) DO UPDATE
SET
  color = EXCLUDED.color,
  updated_at = now(),
  deleted_at = NULL;
