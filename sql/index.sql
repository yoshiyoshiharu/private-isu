ALTER TABLE posts ADD COLUMN comment_count integer DEFAULT 0;
CREATE INDEX index_comments_post_id_created_at ON comments (post_id, created_at);
CREATE INDEX index_comments_user_id ON comments (user_id);
CREATE INDEX index_posts_user_id_created_at ON posts (user_id, created_at);
CREATE INDEX index_posts_created_at ON posts (created_at);
