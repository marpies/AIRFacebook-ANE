package com.marpies.demo.facebook.data {

    public class FacebookPermissions {

        public static const LIST:Array = [
            {
                header: "Common",
                children:
                        [
                            { text: "email", isSelected: false },
                            { text: "user_about_me", isSelected: false },
                            { text: "user_birthday", isSelected: false },
                            { text: "user_friends", isSelected: false }
                        ]
            },
            {
                header: "User",
                children:
                        [
                            { text: "user_actions.books", isSelected: false },
                            { text: "user_actions.fitness", isSelected: false },
                            { text: "user_actions.music", isSelected: false },
                            { text: "user_actions.video", isSelected: false },
                            { text: "user_activities", isSelected: false },
                            { text: "user_education_history", isSelected: false },
                            { text: "user_events", isSelected: false },
                            { text: "user_games_activity", isSelected: false },
                            { text: "user_groups", isSelected: false },
                            { text: "user_hometown", isSelected: false },
                            { text: "user_interests", isSelected: false },
                            { text: "user_likes", isSelected: false },
                            { text: "user_location", isSelected: false },
                            { text: "user_photos", isSelected: false },
                            { text: "user_posts", isSelected: false },
                            { text: "user_relationships", isSelected: false },
                            { text: "user_relationship_details", isSelected: false },
                            { text: "user_religion_politics", isSelected: false },
                            { text: "user_status", isSelected: false },
                            { text: "user_tagged_places", isSelected: false },
                            { text: "user_videos", isSelected: false },
                            { text: "user_website", isSelected: false },
                            { text: "user_work_history", isSelected: false },
                        ]
            },
            {
                header: "Extended",
                children:
                        [
                            { text: "read_custom_friendlists", isSelected: false },
                            { text: "read_insights", isSelected: false },
                            { text: "read_mailbox", isSelected: false },
                            { text: "read_page_mailboxes", isSelected: false },
                            { text: "read_stream", isSelected: false },
                            { text: "manage_notifications", isSelected: false },
                            { text: "manage_pages", isSelected: false },
                            { text: "publish_pages", isSelected: false },
                            { text: "publish_actions", isSelected: false },
                            { text: "rsvp_event", isSelected: false }
                        ]
            }
        ];

    }

}
